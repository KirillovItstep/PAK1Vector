using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Windows.Forms;
using System.IO;
using CorelDraw;
using Corel.Interop.VGCore;

namespace CopyLayers
{
    public partial class FormMain : Form
    {
        private string fileName; //Имя открываемого файла
        private string directoryName; //Имя каталога
        private string pathExe; //Имя каталога с исполняемым файлом
        private string ex, ey;
        IniFile ini = null;

        public FormMain()
        {
            InitializeComponent();
            System.Windows.Forms.Cursor.Current = System.Windows.Forms.Cursors.Arrow; 
            //Прочитать данные из ini-файла
            var assembly = System.Reflection.Assembly.GetEntryAssembly().Location;
            var path = System.IO.Path.GetDirectoryName(assembly);
            pathExe = path + "\\";
            ini = new IniFile(Path.Combine(pathExe, "settings.ini"));

            //Console.WriteLine(Path.Combine(pathExe, "settings.ini"));
            
            //Прочитать все исходные данные из ini файла
            textBoxx0.Text = ini.Read("x0", "settings");
            textBoxy0.Text = ini.Read("y0", "settings");
            textBoxa.Text = ini.Read("a", "settings");
            textBoxb.Text = ini.Read("b", "settings");
            textBoxw.Text = ini.Read("w", "settings");
            textBoxh.Text = ini.Read("h", "settings");

            textBoxx02.Text = ini.Read("x0", "settings");
            textBoxy02.Text = ini.Read("y0", "settings");
            textBoxa2.Text = ini.Read("a", "settings");
            textBoxb2.Text = ini.Read("b", "settings");
            textBoxw2.Text = ini.Read("w", "settings");
            textBoxh2.Text = ini.Read("h", "settings");

            ex = ini.Read("ex", "settings");
            ey = ini.Read("ey", "settings");
        }

        private void выходToolStripMenuItem_Click(object sender, EventArgs e)
        {
            Close();
        }

        private void button2_Click(object sender, EventArgs e)
        {
           
            //Прочитать все исходные данные
            double x0 = Convert.ToDouble(textBoxx02.Text);
            double y0 = Convert.ToDouble(textBoxy02.Text);
            double a = Convert.ToDouble(textBoxa2.Text);
            double b = Convert.ToDouble(textBoxb2.Text);
            double w = Convert.ToDouble(textBoxw2.Text);
            double h = Convert.ToDouble(textBoxh2.Text);

            //Сохранить все данные в ini файл
            ini.Write("x0", textBoxx02.Text, "settings");
            ini.Write("y0", textBoxy02.Text, "settings");
            ini.Write("a", textBoxa2.Text, "settings");
            ini.Write("b", textBoxb2.Text, "settings");
            ini.Write("w", textBoxw2.Text, "settings");
            ini.Write("h", textBoxh2.Text, "settings");

            //Запустить CorelDraw
            CorelDraw.CorelDraw corelDraw = new CorelDraw.CorelDraw(true);
            
            //Открыть каталог
            folderBrowserDialog1.RootFolder = Environment.SpecialFolder.Desktop;
            folderBrowserDialog1.SelectedPath = pathExe;
            //Console.WriteLine(pathExe);
                
            if (folderBrowserDialog1.ShowDialog() == DialogResult.OK)
            {
                directoryName = folderBrowserDialog1.SelectedPath;
                //Получить список файлов
                string[] fileList = Directory.GetFiles(directoryName);
                DateTime[] creationTimes = new DateTime[fileList.Length];
                for (int i = 0; i < fileList.Length; i++)                
                    creationTimes[i] = new FileInfo(fileList[i]).CreationTime;
                    //textBox1.AppendText(fileList[i]);
                Array.Sort(creationTimes, fileList);
                //for (int i = 0; i < fileList.Length; i++) listBox1.Items.Add(fileList[i]);
                int count = fileList.Length;
                //Открыть первый файл
                fileName = fileList[0];
                try
                {
                    corelDraw.openDocument(fileName);
                }
                catch (Exception e2)
                {
                    MessageBox.Show("Не удалось открыть файл", "Ошибка", MessageBoxButtons.OK, MessageBoxIcon.Error);
                }
                //Сохранить документ как
                if (saveFileDialog1.ShowDialog() == DialogResult.OK)
                {
                    fileName = saveFileDialog1.FileName;
                    //string ext = Path.GetExtension(fileName);
                    int pos = fileName.IndexOf(".cdr");
                    if (pos == -1) fileName = fileName + ".cdr";
                    try
                    {
                        corelDraw.saveDocumentAs(fileName);
                    }
                    catch (Exception e2)
                    {
                        MessageBox.Show("Не удалось сохранить файл", "Ошибка", MessageBoxButtons.OK, MessageBoxIcon.Error);
                        return;
                    }
                }
                //corelDraw.setPageSize(w, h);
                //Определить размеры изображения
                Drawer drawer = new Drawer(corelDraw);
                
                drawer.getImageSize(fileName);
                double width = drawer.Width;
                double height = drawer.Height;
                
                //Определить количество рисунков по горизонтали и вертикали
                int m = Convert.ToInt32(Math.Floor((w - x0 * 2 + a) / (width + a)));
                int n = Convert.ToInt32(Math.Floor((h - y0 * 2 + b) / (height + b)));
                string message = String.Concat("Все изображения не помещаются на раскладке\nФайлов - ", Convert.ToString(count), "\nМест - ", Convert.ToString(n * m));
                if (count > n * m)
                {
                    MessageBox.Show(message, "Предупреждение", MessageBoxButtons.OK, MessageBoxIcon.Warning);
                    count = n * m;
                }
                //считывание смещения на значение погрешности
                double[] xx = new double[count];
                double[] yy = new double[count];

                String[] coordX = ex.Split(new char[] { ' ' }, StringSplitOptions.RemoveEmptyEntries);
                for (int i = 0; i < coordX.Length; i++)
                {
                    xx[i] = Convert.ToDouble(coordX[i]);
                }

                String[] coordY = ex.Split(new char[] { ' ' }, StringSplitOptions.RemoveEmptyEntries);
                for (int i = 0; i < coordY.Length; i++)
                {
                    yy[i] = Convert.ToDouble(coordY[i]);
                }

                                //Переместить первый рисунок в нужную позицию                
                double x, y;
                drawer.copySelection();
                drawer.moveSelection(w-x0-width+xx[0], y0+height+yy[0]);
                //Добавить рисунки
                label14.Text = "Обработка";
                for (int i = 1; i < count; i++)
                {
                    //Открывается новый файл
                    corelDraw.openDocument(fileList[i]);
                    //Копируется в буфер
                    drawer.copySelection();
                    //Закрывается
                    corelDraw.closeDocument();
                    //Вставка из буфера
                    drawer.pasteSelection();
                    //Перемещение                    
                    x = w-(x0 + (i / n) * (width + a))-width+xx[i];
                    y = y0 + (i % n) * (height + b)+height+yy[i];
                    drawer.moveSelection(x,y);
                    int value = Convert.ToInt32(Math.Floor(Convert.ToDouble(i * 100.0 / (count-1))));
                    if (value > 100) value = 100;
                    progressBar2.Value = value;
                    if (progressBar2.Value == 100)
                    {
                        progressBar2.Value = 0;
                        label14.Text = "Готово";
                    }
                }
                
                //Прямоугольник вокруг изображения
                drawer.LineWidth = 0.0762;
                drawer.line(0, 0, w, 0);
                drawer.line(w, 0, w, h);
                drawer.line(0, h, w, h);
                drawer.line(0, 0, 0, h);
                corelDraw.saveDocument();
                corelDraw.closeDocument();
            }
        }

        private void button1_Click_1(object sender, EventArgs e)
        {
            //Прочитать все исходные данные
            double x0 = Convert.ToDouble(textBoxx0.Text);
            double y0 = Convert.ToDouble(textBoxy0.Text);
            double a = Convert.ToDouble(textBoxa.Text);
            double b = Convert.ToDouble(textBoxb.Text);
            double w = Convert.ToDouble(textBoxw.Text);
            double h = Convert.ToDouble(textBoxh.Text);

            //Сохранить все данные в ini файл
            ini.Write("x0", textBoxx0.Text, "settings");
            ini.Write("y0", textBoxy0.Text, "settings");
            ini.Write("a", textBoxa.Text, "settings");
            ini.Write("b", textBoxb.Text, "settings");
            ini.Write("w", textBoxw.Text, "settings");
            ini.Write("h", textBoxh.Text, "settings");

            //Запустить CorelDraw
            CorelDraw.CorelDraw corelDraw = new CorelDraw.CorelDraw(true);            
            //Открыть документ
            openFileDialog1.Filter = "Файлы CorelDraw (*.cdr)|*.cdr";
            if (openFileDialog1.ShowDialog() == DialogResult.OK)
            {
                fileName = openFileDialog1.FileName;
                try
                {
                    corelDraw.openDocument(fileName);
                }
                catch (Exception e2)
                {
                    MessageBox.Show("Не удалось открыть файл", "Ошибка", MessageBoxButtons.OK, MessageBoxIcon.Error);
                }
                //Сохранить документ как
                if (saveFileDialog1.ShowDialog() == DialogResult.OK)
                {
                    fileName = saveFileDialog1.FileName;
                    //string ext = Path.GetExtension(fileName);
                    int pos = fileName.IndexOf(".cdr");
                    if (pos == -1) fileName = fileName + ".cdr";
                    corelDraw.saveDocumentAs(fileName);
                }
                //corelDraw.setPageSize(w, h);
                //Определить размеры изображения
                Drawer drawer = new Drawer(corelDraw);
                
                drawer.getImageSize(fileName);
                double width = drawer.Width;
                double height = drawer.Height;
                //Определить количество рисунков по горизонтали и вертикали
                int n = Convert.ToInt32(Math.Floor((w - x0 * 2 + a) / (width + a)));
                int m = Convert.ToInt32(Math.Floor((h - y0 * 2 + b) / (height + b)));
                //Вырезать рисунок в буфер обмена
                int count = corelDraw.Document.ActivePage.Layers.Count;

                for (int k = 0; k < count; k++)
                {
                    Layer layer = corelDraw.Document.ActivePage.Layers[k];
                }
                drawer.groupAll();
                drawer.cutSelection();
                label13.Text = "Обработка";
                for (int i = 0; i <n; i++)
                for (int j = 0; j <m; j++)                    
                    {
                        drawer.pasteSelection();
                        drawer.moveSelection(x0 + i * (width + a), h-(y0 + j * (height + b)));
                        int value = Convert.ToInt32(Math.Floor(Convert.ToDouble((i+1)*m+j) * 100.0 / n / m));
                        if (value > 100) value = 100;
                        progressBar1.Value = value;
                        if (progressBar1.Value == 100)
                        {
                            progressBar1.Value = 0;
                            label13.Text = "Готово";
                        }
                    }
                
                //Прямоугольник вокруг изображения
                drawer.LineWidth = 0.0762;
                drawer.line(0, 0, w, 0);
                drawer.line(w, 0, w, h);
                drawer.line(0, h, w, h);
                drawer.line(0, 0, 0, h);
                corelDraw.saveDocument();
                corelDraw.closeDocument();
            }
        }

        private void сохранитьToolStripMenuItem_Click(object sender, EventArgs e)
        {

        }

        private void pictureBox2_Click(object sender, EventArgs e)
        {

        }            
        }
        
    }

