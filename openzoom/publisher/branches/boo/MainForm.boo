namespace OpenZoom

import Microsoft.DeepZoomTools
import System
import System.Collections
import System.Drawing
import System.IO
import System.Windows.Forms

partial class MainForm:
	def constructor():
		// The InitializeComponent() call is required for Windows Forms designer support.
		InitializeComponent()
		
	private def OpenFileDialogFileOk(sender as object, e as System.ComponentModel.CancelEventArgs):
		self.sourceName = openFileDialog.FileName
		//previewPictureBox.ImageLocation = self.sourceName
		importListView.Items.Add(Path.GetFileName(self.sourceName))
		sourceFolderTextBox.Text = self.sourceName
		exportButton.Enabled = true
	
	private def BrowseSourceFolderButtonClick(sender as object, e as System.EventArgs):
		openFileDialog.ShowDialog()
		
	private def ExportButtonClick(sender as object, e as System.EventArgs):
		imageCreator = ImageCreator()	
		imageCreator.TileSize = 254
		imageCreator.TileOverlap = 1
		imageCreator.ImageQuality = 0.95
		imageCreator.TileFormat = ImageFormat.Jpg
		destinationName = Path.GetFileNameWithoutExtension(self.sourceName) + ".dzi"
		imageCreator.Create(self.sourceName, destinationName)

	private sourceName as string
	
	private def Label1Click(sender as object, e as System.EventArgs):
		pass
	
	private def Button1Click(sender as object, e as System.EventArgs):
		pass

[STAThread]
def Main(argv as (string)):
	Application.EnableVisualStyles()
	Application.SetCompatibleTextRenderingDefault(false)
	Application.Run(MainForm())
	