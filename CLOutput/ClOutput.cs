using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using Corel.Interop.VGCore;
using System.IO;

namespace CLOutput
{
    class CorelDraw
    {
        private bool Visible; //Видимость
        private Application application = null; //Приложение CorelDraw            
        private String fileName; //Имя файла     
        private Document document = null; //Документ CorelDraw

        public CorelDraw(bool Visible)
        {
            this.Visible = Visible;
            Type pType = Type.GetTypeFromProgID("CorelDRAW.Application.17");
            application = Activator.CreateInstance(pType) as Application;
            //Максимизировать окно
            application.AppWindow.WindowState = Corel.Interop.VGCore.cdrWindowState.cdrWindowMaximized;
            application.Visible = Visible;
        }

        //Открыть документ
        public void openDocument(String fileName)
        {
            this.fileName = fileName;
            application.OpenDocument(fileName, 1);
            document = application.ActiveDocument;
            application.ActiveDocument.Unit = cdrUnit.cdrMillimeter; //Единицы измерения
        }

        //Удалить все слои перед сохранением
        public void deleteLayers()
        {
            //Удалить все слои, кроме одного
            //Определить имена всех слоев
            int count = application.ActivePage.Layers.Count;
            //Console.WriteLine(count);
            string[] names = new string[count];
            for (int i = 0; i < count; i++)
            {
                names[i] = application.ActivePage.Layers[i].Name;
                Console.WriteLine(names[i]);
            }
            //Удаляются все слои, начинающиеся на строчную латинскую букву
            for (int i = 0; i < count; i++)
                if (names[i][0] >= 'a' && names[i][0] <= 'z')
                {
                    Layer layer = application.ActivePage.Layers[names[i]];
                    layer.Delete();
                }
        }

        //Сохранить документ как...
        public void saveDocumentAs(String fileName)
        {
            this.fileName = fileName;
            //Опции при сохранении
            Corel.Interop.VGCore.StructSaveAsOptions options = new Corel.Interop.VGCore.StructSaveAsOptions();
            options.Overwrite = true;
            options.EmbedVBAProject = true;
            options.Filter = Corel.Interop.VGCore.cdrFilter.cdrCDR;
            options.IncludeCMXData = false;
            options.Range = Corel.Interop.VGCore.cdrExportRange.cdrAllPages;
            options.EmbedICCProfile = false;
            options.Version = Corel.Interop.VGCore.cdrFileVersion.cdrVersion17;
            options.KeepAppearance = true;
            application.ActiveDocument.SaveAs(fileName, options);
            document = application.ActiveDocument;
        }

        //Сохранить документ как jpg...
        public void saveDocumentAsJPG(String fileName)
        {
            this.fileName = fileName;
            //Опции при сохранении
            Corel.Interop.VGCore.StructSaveAsOptions options = new Corel.Interop.VGCore.StructSaveAsOptions();
            options.Overwrite = true;
            options.EmbedVBAProject = true;
            options.Filter = Corel.Interop.VGCore.cdrFilter.cdrJPEG;
            options.IncludeCMXData = false;
            options.Range = Corel.Interop.VGCore.cdrExportRange.cdrAllPages;
            options.EmbedICCProfile = false;
            options.Version = Corel.Interop.VGCore.cdrFileVersion.cdrVersion17;
            options.KeepAppearance = true;
            application.ActiveDocument.SaveAs(fileName, options);
            document = application.ActiveDocument;
        }

        //Импортировать рисунок на активный слой
        public void importJPG(String fileName, double x, double y, double width, double height)
        {
            Corel.Interop.VGCore.StructImportOptions options = new Corel.Interop.VGCore.StructImportOptions();
            options.Mode = Corel.Interop.VGCore.cdrImportMode.cdrImportFull;
            options.CombineMultilayerBitmaps = false;
            options.ExtractICCProfile = false;
            options.DetectWatermark = true;
            options.LinkBitmapExternally = false;
            options.MaintainLayers = true;
            options.UseOPILinks = false;
            application.ActiveDocument.ActiveLayer.Import(fileName, cdrFilter.cdrJPEG, options);
            application.ActiveDocument.ActiveShape.SetSize(width, height);
            application.ActiveDocument.ActiveShape.SetPosition(x, y + height);
            Layer layer = application.ActivePage.ActiveLayer;
            application.ActiveDocument.ActiveShape.Layer.MoveBelow(layer);
        }

        //Установить размер страницы
        public void setPageSize(double width, double height)
        {
            application.ActiveDocument.MasterPage.SetSize(width, height);
        }

        //Выделить слой
        public void selectLayer(String name)
        {
            application.ActivePage.Layers[name].Activate();
        }

        //Запустить макрос
        public void runMacro(String module, String name)
        {
            application.GMSManager.RunMacro(module, name, null);
        }

        //Создать новый документ
        public void createDocument()
        {
            if (document == null)
                document = application.CreateDocument();
            document.Unit = cdrUnit.cdrMillimeter; //Единицы измерения
        }

        //Закрыть документ
        public void closeDocument()
        {
            ((Corel.Interop.VGCore.IVGDocument)application.ActiveDocument).Close();
        }

        //Выйти из приложения
        public void quit()
        {
            //Закрыть документ без сохранения
            ((Corel.Interop.VGCore.IVGDocument)application.ActiveDocument).Close();
            ((Corel.Interop.VGCore.IVGApplication)application).Quit();
        }

        public Application getApplication()
        {
            return application;
        }

        public Document getDocument()
        {
            return application.ActiveDocument;
        }

        public String getFileName()
        {
            return fileName;
        }

        public Application Application
        {
            get { return application; }
            set { application = value; }
        }


        public Document Document
        {
            get { return document; }
            set { document = value; }
        }
    }


    class Drawer : IDisposable
    {
        //Приложение
        private CorelDraw corelDraw = null;
        private Application application = null;
        private Document document = null;
        private Color color = null; //Цвет фигур
        private Corel.Interop.VGCore.cdrAlignment alignment = cdrAlignment.cdrLeftAlignment; //Выравнивание текста
        private string sAlignment = ""; //Left, Right, Center        
        private double lineWidth = 0; //Толщина линий
        private string font = "Arial"; //Шрифт
        private float fontSize = 12; //Размер шрифта
        private double width; //Высота и ширина изображения cdr
        private double height;
        private Shape shape; //Текущая фигура     
        // Pointer to an external unmanaged resource.
        private IntPtr handle;
        // Other managed resource this class uses.
        private System.ComponentModel.Component component = new System.ComponentModel.Component();
        // Track whether Dispose has been called.
        private bool disposed = false;
       
        public Drawer(CorelDraw corelDraw)
        {            
            this.corelDraw = corelDraw;
            application = corelDraw.getApplication();
            document = corelDraw.getDocument();
            application.ActiveDocument.Unit = cdrUnit.cdrMillimeter; //Единицы измерения            
            //color = application.CreateRGBColor(0, 0, 0);
            color = application.CreateCMYKColor(0, 0, 0, 100);
            alignment = cdrAlignment.cdrLeftAlignment;
        }

        //Отрезок
        public void line(double x1, double y1, double x2, double y2)
        {
            shape = document.ActiveLayer.CreateLineSegment(x1, y1, x2, y2);
            //Толщина
            shape.Outline.SetProperties(lineWidth, null, color, null, null, cdrTriState.cdrUndefined,
                cdrTriState.cdrUndefined, cdrOutlineLineCaps.cdrOutlineUndefinedLineCaps,
                cdrOutlineLineJoin.cdrOutlineUndefinedLineJoin, -9999, 0, -1, 1, 0);
        }

        //Преобразовать активную фигуру в заливку
        public void convertToFill()
        {
            document.ActiveShape.Outline.ConvertToObject();
            document.ActiveShape.Fill.ApplyUniformFill(color);
        }

        public void text(string text, double x, double y)
        {
            shape = document.ActiveLayer.CreateArtisticText(x, y, text, cdrTextLanguage.cdrLanguageNone, cdrTextCharSet.cdrCharSetMixed,
            font, fontSize, cdrTriState.cdrUndefined, cdrTriState.cdrUndefined, cdrFontLine.cdrMixedFontLine,alignment);            
            shape.Fill.UniformColor = color;
            shape.Outline.SetNoOutline();
        }

        //Вставка изображения
        public void insertImage(string fileName, double x, double y)
        {
            //Выделить только название
            string shortName = Path.GetFileNameWithoutExtension(fileName);            
            //Выбрать активный документ
            Document document = application.ActiveDocument;
            //Выбрать слой
            application.ActivePage.Layers[shortName].Activate();
            Layer layer = application.ActiveDocument.ActiveLayer;
            layer.Visible = true;

            //Скопировать все
            application.ActiveDocument.ActiveLayer.Shapes.All().CreateSelection();
            application.ActiveSelectionRange.Copy();
            //Вставить на другой слой
            application.ActivePage.Layers["Layer"].Activate();
            application.ActiveDocument.ActiveLayer.Paste();
            layer.Visible = false;
            application.ActiveSelectionRange.CenterX = x;
            application.ActiveSelectionRange.CenterY = y;
        }

        //Размер изображения
        public void getImageSize(string fileName)
        {
            corelDraw.openDocument(fileName);
            int count = document.ActivePage.Layers.Count;
            for (int k = 2; k <= 2; k++)
            {
                Layer layer = document.ActivePage.Layers[k];                
                corelDraw.selectLayer(layer.Name);
                application.ActiveDocument.ActiveLayer.Shapes.All().CreateSelection();                
            }
            application.ActiveDocument.Selection().GetSize(out width, out height);
            corelDraw.closeDocument();            
        }

        //Размер текстовой надписи
        public void getTextSize(string str, out double width, out double height)
        {                        
            text(str, 0, 0);            
            application.ActiveDocument.Selection().GetSize(out width, out height);
            application.ActiveDocument.Selection().Delete();
        }

        public void groupAll()
        {
            application.ActiveDocument.ActiveLayer.Shapes.All().CreateSelection();
            application.ActiveDocument.ActiveLayer.Shapes.All().Group();
        }

        public string Font
        {
            get { return font; }
            set { font = value; }
        }

        public double LineWidth
        {
            get { return lineWidth; }
            set { lineWidth = value; }
        }

        public Color Color
        {
            get { return color; }
            set { color = value; }
        }

        public double Width
        {
            get { return width; }
            set { width = value; }
        }        

        public double Height
        {
            get { return height; }
            set { height = value; }
        }

        public Shape Shape
        {
            get { return shape; }
            set { shape = value; }
        }

        public float FontSize
        {
            get { return fontSize; }
            set { fontSize = value; }
        }

        public void Dispose()
        {
            Dispose(true);            
            GC.SuppressFinalize(this);
        }


        public Corel.Interop.VGCore.cdrAlignment Alignment
        {
            get { return alignment; }
            set { alignment = value; }
        }

        protected virtual void Dispose(bool disposing)
        {
            // Check to see if Dispose has already been called.
            if (!this.disposed)
            {
                // If disposing equals true, dispose all managed
                // and unmanaged resources.
                if (disposing)
                {
                    // Dispose managed resources.                    
                    component.Dispose();
                }

                // Call the appropriate methods to clean up
                // unmanaged resources here.
                // If disposing is false,
                // only the following code is executed.
                CloseHandle(handle);
                handle = IntPtr.Zero;

                // Note disposing has been done.
                disposed = true;
            }
        }

        public string SAlignment
        {
            get { return sAlignment; }
            set
            {
                sAlignment = value;
                if (String.Equals(sAlignment, "Left"))
                    alignment = cdrAlignment.cdrLeftAlignment;
                if (String.Equals(sAlignment, "Right"))
                    alignment = cdrAlignment.cdrRightAlignment;
                if (String.Equals(sAlignment, "Center"))
                    alignment = cdrAlignment.cdrCenterAlignment;
            }
        }


        [System.Runtime.InteropServices.DllImport("Kernel32")]
        private extern static Boolean CloseHandle(IntPtr handle);
    }
    }

