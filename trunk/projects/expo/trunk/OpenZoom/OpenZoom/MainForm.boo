namespace OpenZoom

import System
import System.Collections
import System.Drawing
import System.Windows.Forms

partial class MainForm:
	def constructor():
		// The InitializeComponent() call is required for Windows Forms designer support.
		InitializeComponent()
	
	private def OpenFileDialog1FileOk(sender as object, e as System.ComponentModel.CancelEventArgs):
		pass
		// TODO: Add constructor code after the InitializeComponent() call.

[STAThread]
def Main(argv as (string)):
	Application.EnableVisualStyles()
	Application.SetCompatibleTextRenderingDefault(false)
	Application.Run(MainForm())
	