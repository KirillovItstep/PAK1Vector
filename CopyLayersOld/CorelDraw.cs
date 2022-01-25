using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using Corel.Interop.VGCore;

namespace CorelDraw
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

        //Сохранить документ
        public void saveDocument()
        {            
            application.ActiveDocument.Save();         
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
    }

