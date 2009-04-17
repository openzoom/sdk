using System;
using System.IO;
using System.Net;
using System.Windows;
using System.Windows.Controls;
using System.Windows.Data;
using System.Windows.Media;
using System.Windows.Media.Animation;
using System.Windows.Navigation;
using System.Windows.Forms;

namespace OpenZoomPublisher
{
	public partial class MainWindow
	{
        public MainWindow()
		{
			this.InitializeComponent();
			
			// Insert code required on object creation below this point.
		}

        private void addImage_Click(object sender, RoutedEventArgs e)
        {
            OpenFileDialog openFileDialog = new OpenFileDialog();
            openFileDialog.Multiselect = true;
            openFileDialog.Filter = "Image Files (*.jpg, *.png)|*.jpg;*.jpeg;*.png";

            if (openFileDialog.ShowDialog() == System.Windows.Forms.DialogResult.OK)
            {
                foreach (String file in openFileDialog.FileNames)
                {
                    //imageListBox.Items.Add(Path.GetFileName(file));
                    imageListBox.Items.Add(file);
                }
            }
        }

        private void export_Click(object sender, RoutedEventArgs e)
        {

        }

        private void browseOutputFolder_Click(object sender, RoutedEventArgs e)
        {
            FolderBrowserDialog folderBrowserDialog = new FolderBrowserDialog();


            if (folderBrowserDialog.ShowDialog() == System.Windows.Forms.DialogResult.OK)
            {
                outputFolderTextBox.Text = folderBrowserDialog.SelectedPath;
            }
        }
	}
}