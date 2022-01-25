using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using Corel.Interop.VGCore;
using System.IO;

namespace CorelDraw
{
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
            color = application.CreateRGBColor(0, 0, 0);
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
            font, fontSize, cdrTriState.cdrUndefined, cdrTriState.cdrUndefined, cdrFontLine.cdrMixedFontLine, alignment);
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
                Layer layer = document.ActivePage.ActiveLayer;
                corelDraw.selectLayer(layer.Name);
                application.ActiveDocument.ActiveLayer.Shapes.All().CreateSelection();         
                application.ActiveDocument.Selection().GetSize(out width, out height);         
        }

        //Размер текстовой надписи
        public void getTextSize(string str, out double width, out double height)
        {
            text(str, 0, 0);
            application.ActiveDocument.Selection().GetSize(out width, out height);
            application.ActiveDocument.Selection().Delete();
        }

        //Сгруппировать все элементы
        public void groupAll()
        {            
            application.ActiveDocument.ActiveLayer.Shapes.All().CreateSelection();
            application.ActiveDocument.ActiveLayer.Shapes.All().Group();
        }

        //Вырезать выделение
        public void cutSelection()
        {
            //Выделяются элементы со всех слоев
            application.ActiveDocument.ActivePage.Shapes.All().CreateSelection();
            application.ActiveSelectionRange.Cut();
        }

        //Копировать выделение
        public void copySelection()
        {
            //Выделяются элементы со всех слоев
            application.ActiveDocument.ActivePage.Shapes.All().CreateSelection();
            application.ActiveSelectionRange.Copy();
        }


        //Вставить из буфера обмена
        public void pasteSelection()
        {            
            application.ActiveDocument.ActiveLayer.Paste();
        }

        //Переместить выделение в заданное положение
        public void moveSelection(double x, double y)
        {
            application.ActiveDocument.Selection().SetPosition(x, y);
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