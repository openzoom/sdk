namespace OpenZoom

partial class MainForm(System.Windows.Forms.Form):
	private components as System.ComponentModel.IContainer = null
	
	protected override def Dispose(disposing as bool):
		if disposing:
			if components is not null:
				components.Dispose()
		super(disposing)
	
	// This method is required for Windows Forms designer support.
	// Do not change the method contents inside the source code editor. The Forms designer might
	// not be able to load this method if it was changed manually.
	def InitializeComponent():
		self.sourceFolderLabel = System.Windows.Forms.Label()
		self.sourceFolderTextBox = System.Windows.Forms.TextBox()
		self.browseSourceFolderButton = System.Windows.Forms.Button()
		self.exportButton = System.Windows.Forms.Button()
		self.openFileDialog = System.Windows.Forms.OpenFileDialog()
		self.SuspendLayout()
		# 
		# sourceFolderLabel
		# 
		self.sourceFolderLabel.Location = System.Drawing.Point(12, 9)
		self.sourceFolderLabel.Name = "sourceFolderLabel"
		self.sourceFolderLabel.Size = System.Drawing.Size(73, 17)
		self.sourceFolderLabel.TabIndex = 0
		self.sourceFolderLabel.Text = "Source Folder"
		# 
		# sourceFolderTextBox
		# 
		self.sourceFolderTextBox.Location = System.Drawing.Point(91, 4)
		self.sourceFolderTextBox.Name = "sourceFolderTextBox"
		self.sourceFolderTextBox.Size = System.Drawing.Size(315, 20)
		self.sourceFolderTextBox.TabIndex = 1
		# 
		# browseSourceFolderButton
		# 
		self.browseSourceFolderButton.Location = System.Drawing.Point(412, 4)
		self.browseSourceFolderButton.Name = "browseSourceFolderButton"
		self.browseSourceFolderButton.Size = System.Drawing.Size(27, 23)
		self.browseSourceFolderButton.TabIndex = 2
		self.browseSourceFolderButton.Text = "..."
		self.browseSourceFolderButton.UseVisualStyleBackColor = true
		self.browseSourceFolderButton.Click += self.BrowseSourceFolderButtonClick as System.EventHandler
		# 
		# exportButton
		# 
		self.exportButton.Enabled = false
		self.exportButton.Location = System.Drawing.Point(364, 39)
		self.exportButton.Name = "exportButton"
		self.exportButton.Size = System.Drawing.Size(75, 23)
		self.exportButton.TabIndex = 3
		self.exportButton.Text = "Export"
		self.exportButton.UseVisualStyleBackColor = true
		self.exportButton.Click += self.ExportButtonClick as System.EventHandler
		# 
		# openFileDialog
		# 
		self.openFileDialog.DefaultExt = "jpg"
		self.openFileDialog.Filter = "Image Files (*.jpg, *.png)|*.jpg||*.png"
		self.openFileDialog.Title = "Choose Image File"
		self.openFileDialog.FileOk += self.OpenFileDialogFileOk as System.ComponentModel.CancelEventHandler
		# 
		# MainForm
		# 
		self.AutoScaleDimensions = System.Drawing.SizeF(6, 13)
		self.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font
		self.ClientSize = System.Drawing.Size(451, 74)
		self.Controls.Add(self.exportButton)
		self.Controls.Add(self.browseSourceFolderButton)
		self.Controls.Add(self.sourceFolderTextBox)
		self.Controls.Add(self.sourceFolderLabel)
		self.Name = "MainForm"
		self.Text = "OpenZoom Exporter"
		self.ResumeLayout(false)
		self.PerformLayout()
	private openFileDialog as System.Windows.Forms.OpenFileDialog
	private exportButton as System.Windows.Forms.Button
	private browseSourceFolderButton as System.Windows.Forms.Button
	private sourceFolderTextBox as System.Windows.Forms.TextBox
	private sourceFolderLabel as System.Windows.Forms.Label