using System;
using System.Collections.ObjectModel;
using System.IO;
using System.Windows;
using System.Windows.Controls;
using System.Windows.Forms;
using System.Xml.Linq;
using Microsoft.DeepZoomTools;
using System.Drawing;
using System.ComponentModel;
using System.Drawing.Drawing2D;

namespace OpenZoom.Publisher
{
    public partial class MainWindow
    {
        private const int DEFAULT_TILE_SIZE = 254;
        private const int DEFAULT_TILE_OVERLAP = 1;

        private XNamespace deepzoomNS;
        private XNamespace openzoomNS;

        private ImageCreator imageCreator;
        private ImagesFormData imagesFormData;
        private GeneralFormData generalFormData;
        private SourceFormData sourceFormData;
        private PyramidFormData pyramidFormData;

        private const String applicationDirectory = "OpenZoom";
        private String applicationDirectoryPath;

        public MainWindow()
        {
            this.InitializeComponent();

            deepzoomNS = "http://schemas.microsoft.com/deepzoom/2008";
            openzoomNS = "http://ns.openzoom.org/2008";

            imageCreator = new ImageCreator();
            imageCreator.TileSize = DEFAULT_TILE_SIZE;
            imageCreator.TileOverlap = DEFAULT_TILE_OVERLAP;

            imagesFormData = (ImagesFormData)(Resources["imagesFormData"]);
            generalFormData = (GeneralFormData)(Resources["generalFormData"]);
            sourceFormData = (SourceFormData)(Resources["sourceFormData"]);
            pyramidFormData = (PyramidFormData)(Resources["pyramidFormData"]);

            // Create app data directory
            applicationDirectoryPath = Path.Combine(System.Environment.GetFolderPath(Environment.SpecialFolder.MyDocuments), applicationDirectory);

            if (!Directory.Exists(applicationDirectoryPath))
                Directory.CreateDirectory(applicationDirectoryPath);

            generalFormData.OutputFolderPath = applicationDirectoryPath;
        }

        private void addImagesButton_Click(object sender, RoutedEventArgs e)
        {
            OpenFileDialog openFileDialog = new OpenFileDialog();
            openFileDialog.InitialDirectory = System.Environment.GetFolderPath(Environment.SpecialFolder.MyPictures);
            openFileDialog.Multiselect = true;
            openFileDialog.Filter = "Image Files (*.jpg, *.png)|*.jpg;*.jpeg;*.png";

            if (openFileDialog.ShowDialog() == System.Windows.Forms.DialogResult.OK)
            {
                foreach (String file in openFileDialog.FileNames)
                {
                    Image image = new Image(file);
                    imagesFormData.Images.Add(image);
                }
            }
        }

        private void exportButton_Click(object sender, RoutedEventArgs e)
        {
            // Bad karma
            if (!Directory.Exists(generalFormData.OutputFolderPath))
            {
                System.Windows.Forms.MessageBox.Show("Output path does not exist.");
                return;
            }

            imageCreator.ImageQuality = qualitySlider.Value / 100.0;

            foreach (Image image in imagesFormData.Images)
            {
                String imageFileName = Path.GetFileName(image.Path);
                String imageBaseName = Path.GetFileNameWithoutExtension(imageFileName);
                String imageExtension = Path.GetExtension(image.Path);
                String imageDirectory = Path.Combine(Path.GetFullPath(generalFormData.OutputFolderPath), imageBaseName);
                Directory.CreateDirectory(imageDirectory);

                ComboBoxItem selectedItem = fileFormatComboBox.SelectedItem as ComboBoxItem;

                if (selectedItem != null)
                {
                    String fileFormat = selectedItem.Content.ToString();
                    if (fileFormat == "Auto")
                    {
                        if (imageExtension == ".png")
                            imageCreator.TileFormat = ImageFormat.Png;
                        else
                            imageCreator.TileFormat = ImageFormat.Jpg;
                    }

                    if (fileFormat == "JPEG")
                        imageCreator.TileFormat = ImageFormat.Jpg;

                    if (fileFormat == "PNG")
                        imageCreator.TileFormat = ImageFormat.Png;
                }

                String dziPath = Path.Combine(imageDirectory, "image.dzi");
                imageCreator.Create(image.Path, dziPath);

                using (System.Drawing.Image bitmap = System.Drawing.Image.FromFile(image.Path))
                {
                    XElement dzi = XElement.Load(dziPath);
                    dzi.Add(new XAttribute(XNamespace.Xmlns + "openzoom", openzoomNS.NamespaceName));

                    if (exportOriginalCheckBox.IsChecked == true)
                    {
                        File.Copy(image.Path, Path.Combine(imageDirectory, imageFileName), true);

                        ImageSource imageSource = new ImageSource();
                        imageSource.Uri = imageFileName;
                        imageSource.Width = bitmap.Width;
                        imageSource.Height = bitmap.Height;
                        imageSource.Format = imageExtension == ".png" ?
                                                System.Drawing.Imaging.ImageFormat.Png :
                                                System.Drawing.Imaging.ImageFormat.Jpeg;
                        addSourceElement(dzi, imageSource);
                    }

                    sourceFormData.ResizeContraint = (ResizeContraint)resizeConstraintComboBox.SelectedIndex;

                    switch (sourceFormData.ResizeContraint)
                    {
                        case ResizeContraint.LongEdge:
                            {
                                double aspectRatio = bitmap.Width / (double)bitmap.Height;

                                ImageSource imageSource = new ImageSource();

                                if (aspectRatio > 1.0)
                                {
                                    imageSource.Width = sourceFormData.ResizeValue;
                                    imageSource.Height = (int)(sourceFormData.ResizeValue / aspectRatio);
                                }
                                else
                                {
                                    imageSource.Width = (int)(sourceFormData.ResizeValue * aspectRatio);
                                    imageSource.Height = sourceFormData.ResizeValue;
                                }

                                imageSource.Format = imageExtension == ".png" ?
                                                        System.Drawing.Imaging.ImageFormat.Png :
                                                        System.Drawing.Imaging.ImageFormat.Jpeg;
                                imageSource.Uri = imageBaseName + "-" + imageSource.Width + "x" + imageSource.Height + imageExtension;

                                using (Bitmap output = new Bitmap(imageSource.Width, imageSource.Height))
                                {
                                    Graphics g = Graphics.FromImage((System.Drawing.Image)output);
                                    g.InterpolationMode = InterpolationMode.HighQualityBicubic;

                                    g.DrawImage(bitmap, 0, 0, imageSource.Width, imageSource.Height);
                                    g.Dispose();

                                    output.Save(Path.Combine(imageDirectory, imageSource.Uri));
                                }

                                addSourceElement(dzi, imageSource);
                                break;
                            }
                    }

                    dzi.Save(dziPath, SaveOptions.None);
                }
            }

            if (afterExportComboBox.SelectedIndex == 1)
                System.Diagnostics.Process.Start("explorer.exe", generalFormData.OutputFolderPath);
        }

        private void addSourceElement(XElement element, ImageSource imageSource)
        {
            element.Add(new XElement(openzoomNS + "source",
                        new XAttribute("uri", imageSource.Uri),
                        new XAttribute("width", imageSource.Width),
                        new XAttribute("height", imageSource.Height),
                        new XAttribute("type", imageSource.Type)));
        }

        private void browseOutputFolderButton_Click(object sender, RoutedEventArgs e)
        {
            FolderBrowserDialog folderBrowserDialog = new FolderBrowserDialog();
            folderBrowserDialog.SelectedPath = generalFormData.OutputFolderPath;

            if (folderBrowserDialog.ShowDialog() == System.Windows.Forms.DialogResult.OK)
                generalFormData.OutputFolderPath = folderBrowserDialog.SelectedPath;
        }

        private void clearButton_Click(object sender, RoutedEventArgs e)
        {
            if (imagesFormData.Images != null)
                imagesFormData.Images.Clear();
        }
    }

    public class ImagesFormData
    {
        private ObservableCollection<Image> images = new ObservableCollection<Image>();

        public ObservableCollection<Image> Images
        {
            get { return images; }
            set { images = value; }
        }
    }

    public class GeneralFormData : INotifyPropertyChanged
    {
        public GeneralFormData()
        {
            outputFolderPath = "";
        }

        #region INotifyPropertyChanged Members

        public event PropertyChangedEventHandler PropertyChanged;

        #endregion

        private String outputFolderPath;

        public String OutputFolderPath
        {
            get { return outputFolderPath; }
            set
            {
                outputFolderPath = value;
                OnPropertyChanged("OutputFolderPath");
            }
        }

        protected void OnPropertyChanged(string name)
        {
            PropertyChangedEventHandler handler = PropertyChanged;

            if (handler != null)
                handler(this, new PropertyChangedEventArgs(name));
        }
    }

    public class SourceFormData
    {
        public ResizeContraint ResizeContraint
        {
            get;
            set;
        }

        private int resizeValue = 500;

        public int ResizeValue
        {
            get { return resizeValue; }
            set { resizeValue = value; }
        }

        public Boolean DontEnlarge
        {
            get;
            set;
        }

        public Boolean ExportOriginal
        {
            get;
            set;
        }
    }

    public class PyramidFormData
    {
        public FileFormat FileFormat
        {
            get;
            set;
        }

        public Double Quality
        {
            get;
            set;
        }
    }

    public class AfterExportFormData
    {
        public ExportAction ExportAction
        {
            get;
            set;
        }
    }

    public class Image
    {
        public Image(String path)
        {
            Path = path;
        }

        public String Path
        {
            get;
            set;
        }

        public ImageSource[] Sources
        {
            get;
            set;
        }
    }

    public class ImageSource
    {
        public int Width
        {
            get;
            set;
        }

        public int Height
        {
            get;
            set;
        }

        public System.Drawing.Imaging.ImageFormat Format
        {
            get;
            set;
        }

        public String Type
        {
            get
            {
                if (Format == System.Drawing.Imaging.ImageFormat.Jpeg)
                    return "image/jpeg";

                if (Format == System.Drawing.Imaging.ImageFormat.Png)
                    return "image/png";

                throw new NotSupportedException("ImageSource.Type");
            }
        }

        public String Uri
        {
            get;
            set;
        }
    }

    public enum FileFormat
    {
        Auto,
        JPEG,
        PNG
    }

    public enum ExportAction
    {
        DoNothing,
        ShowInExplorer
    }

    public enum ResizeContraint
    {
        LongEdge,
        ShortEdge,
        Width,
        Height
    }
}
