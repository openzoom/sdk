using System;
using System.Collections.ObjectModel;
using System.IO;
using System.Windows;
using System.Windows.Controls;
using System.Windows.Forms;
using System.Xml.Linq;
using Microsoft.DeepZoomTools;

namespace OpenZoom.Publisher
{
    public class Image
    {
        public Image(String path)
        {
            this.Path = path;
        }

        public String Path
        {
            get;
            set;
        }
    }

    public enum TileFormat
    {
        Auto,
        JPEG,
        PNG
    }

	public partial class MainWindow
	{
        private const int DEFAULT_TILE_SIZE = 254;
        private const int DEFAULT_TILE_OVERLAP = 1;

        private ImageCreator imageCreator;
        private ObservableCollection<Image> images;
        private String outputFolderPath;

        public MainWindow()
		{
			this.InitializeComponent();
			
			// Insert code required on object creation below this point.
            imageCreator = new ImageCreator();
            imageCreator.TileSize = DEFAULT_TILE_SIZE;
            imageCreator.TileOverlap = DEFAULT_TILE_OVERLAP;

            images = new ObservableCollection<Image>();
		}

        private void addImagesButton_Click(object sender, RoutedEventArgs e)
        {
            OpenFileDialog openFileDialog = new OpenFileDialog();
            openFileDialog.Multiselect = true;
            openFileDialog.Filter = "Image Files (*.jpg, *.png)|*.jpg;*.jpeg;*.png";

            if (openFileDialog.ShowDialog() == System.Windows.Forms.DialogResult.OK)
            {
                foreach (String file in openFileDialog.FileNames)
                {
                    Image image = new Image(file);
                    images.Add(image);
                }
            }

            imageListBox.ItemsSource = images;
            clearButton.Visibility = Visibility.Visible;
        }

        private void exportButton_Click(object sender, RoutedEventArgs e)
        {
            if (!Directory.Exists(outputFolderPath))
            {
                System.Windows.Forms.MessageBox.Show("Output path not set!! ;)");
                return;
            }

            imageCreator.ImageQuality = qualitySlider.Value / 100.0;

            foreach (Image image in images)
            {
                String imageFileName = Path.GetFileName(image.Path);
                String imageBaseName = Path.GetFileNameWithoutExtension(imageFileName);
                String imageExtension = Path.GetExtension(image.Path);
                String imageDirectory = Path.Combine(Path.GetFullPath(outputFolderTextBox.Text), imageBaseName);
                Directory.CreateDirectory(imageDirectory);

                if (exportOriginalCheckBox.IsChecked == true)
                    File.Copy(image.Path, Path.Combine(imageDirectory, imageFileName), true);


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

                XNamespace deepzoomNS = "http://schemas.microsoft.com/deepzoom/2008";
                XNamespace openzoomNS = "http://ns.openzoom.org/2008";
                XElement dzi = XElement.Load(dziPath);
                dzi.Add(new XAttribute(XNamespace.Xmlns + "openzoom", "http://ns.openzoom.org/2008"));
                dzi.Add(new XElement(openzoomNS + "source"), imageFileName);
                dzi.Save(dziPath);
            }
        }

        private void browseOutputFolderButton_Click(object sender, RoutedEventArgs e)
        {
            FolderBrowserDialog folderBrowserDialog = new FolderBrowserDialog();

            if (folderBrowserDialog.ShowDialog() == System.Windows.Forms.DialogResult.OK)
            {
                outputFolderPath = folderBrowserDialog.SelectedPath;
                outputFolderTextBox.Text = outputFolderPath;
            }
        }

        private void clearButton_Click(object sender, RoutedEventArgs e)
        {
            if (images != null)
                images.Clear();

            clearButton.Visibility = Visibility.Hidden;
        }
	}
}