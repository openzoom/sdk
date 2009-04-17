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
	public partial class Window1
	{
		public Window1()
		{
			this.InitializeComponent();
			
			// Insert code required on object creation below this point.
		}

        private void addImage_Click(object sender, RoutedEventArgs e)
        {
            OpenFileDialog dialog = new OpenFileDialog();
            dialog.Multiselect = true;
            dialog.Filter = "Image Files (*.jpg, *.png)|*.jpg;*.jpeg;*.png";

            if (dialog.ShowDialog() == System.Windows.Forms.DialogResult.OK)
            {
                foreach (String file in dialog.FileNames)
                {
                    //imageListBox.Items.Add(Path.GetFileName(file));
                    imageListBox.Items.Add(file);
                }
            }
        }
	}
}