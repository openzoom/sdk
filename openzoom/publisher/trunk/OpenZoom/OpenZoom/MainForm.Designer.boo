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
		exportGroupBox as System.Windows.Forms.GroupBox
		self.sourceFolderLabel = System.Windows.Forms.Label()
		self.sourceFolderTextBox = System.Windows.Forms.TextBox()
		self.browseSourceFolderButton = System.Windows.Forms.Button()
		self.exportButton = System.Windows.Forms.Button()
		self.openFileDialog = System.Windows.Forms.OpenFileDialog()
		self.importGroupBox = System.Windows.Forms.GroupBox()
		self.tableLayoutPanel1 = System.Windows.Forms.TableLayoutPanel()
		exportGroupBox = System.Windows.Forms.GroupBox()
		self.importGroupBox.SuspendLayout()
		self.tableLayoutPanel1.SuspendLayout()
		exportGroupBox.SuspendLayout()
		self.SuspendLayout()
		# 
		# sourceFolderLabel
		# 
		self.sourceFolderLabel.Location = System.Drawing.Point(6, 16)
		self.sourceFolderLabel.Name = "sourceFolderLabel"
		self.sourceFolderLabel.Size = System.Drawing.Size(73, 17)
		self.sourceFolderLabel.TabIndex = 0
		self.sourceFolderLabel.Text = "Source Folder"
		# 
		# sourceFolderTextBox
		# 
		self.sourceFolderTextBox.Location = System.Drawing.Point(6, 36)
		self.sourceFolderTextBox.Name = "sourceFolderTextBox"
		self.sourceFolderTextBox.Size = System.Drawing.Size(728, 20)
		self.sourceFolderTextBox.TabIndex = 1
		# 
		# browseSourceFolderButton
		# 
		self.browseSourceFolderButton.Location = System.Drawing.Point(740, 34)
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
		self.exportButton.Location = System.Drawing.Point(692, 220)
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
		# importGroupBox
		# 
		self.importGroupBox.Anchor = cast(System.Windows.Forms.AnchorStyles,(((System.Windows.Forms.AnchorStyles.Top | System.Windows.Forms.AnchorStyles.Bottom) 
						| System.Windows.Forms.AnchorStyles.Left) 
						| System.Windows.Forms.AnchorStyles.Right))
		self.importGroupBox.AutoSize = true
		self.importGroupBox.AutoSizeMode = System.Windows.Forms.AutoSizeMode.GrowAndShrink
		self.importGroupBox.Controls.Add(self.sourceFolderLabel)
		self.importGroupBox.Controls.Add(self.sourceFolderTextBox)
		self.importGroupBox.Controls.Add(self.browseSourceFolderButton)
		self.importGroupBox.Location = System.Drawing.Point(3, 3)
		self.importGroupBox.Name = "importGroupBox"
		self.importGroupBox.Size = System.Drawing.Size(773, 249)
		self.importGroupBox.TabIndex = 4
		self.importGroupBox.TabStop = false
		self.importGroupBox.Text = "Import"
		# 
		# tableLayoutPanel1
		# 
		self.tableLayoutPanel1.Anchor = cast(System.Windows.Forms.AnchorStyles,(((System.Windows.Forms.AnchorStyles.Top | System.Windows.Forms.AnchorStyles.Bottom) 
						| System.Windows.Forms.AnchorStyles.Left) 
						| System.Windows.Forms.AnchorStyles.Right))
		self.tableLayoutPanel1.ColumnCount = 1
		self.tableLayoutPanel1.ColumnStyles.Add(System.Windows.Forms.ColumnStyle(System.Windows.Forms.SizeType.Percent, 50))
		self.tableLayoutPanel1.Controls.Add(self.importGroupBox, 0, 0)
		self.tableLayoutPanel1.Controls.Add(exportGroupBox, 0, 1)
		self.tableLayoutPanel1.Location = System.Drawing.Point(12, 12)
		self.tableLayoutPanel1.Name = "tableLayoutPanel1"
		self.tableLayoutPanel1.RowCount = 2
		self.tableLayoutPanel1.RowStyles.Add(System.Windows.Forms.RowStyle(System.Windows.Forms.SizeType.Percent, 50))
		self.tableLayoutPanel1.RowStyles.Add(System.Windows.Forms.RowStyle(System.Windows.Forms.SizeType.Percent, 50))
		self.tableLayoutPanel1.Size = System.Drawing.Size(779, 510)
		self.tableLayoutPanel1.TabIndex = 5
		# 
		# exportGroupBox
		# 
		exportGroupBox.Anchor = cast(System.Windows.Forms.AnchorStyles,(((System.Windows.Forms.AnchorStyles.Top | System.Windows.Forms.AnchorStyles.Bottom) 
						| System.Windows.Forms.AnchorStyles.Left) 
						| System.Windows.Forms.AnchorStyles.Right))
		exportGroupBox.AutoSize = true
		exportGroupBox.AutoSizeMode = System.Windows.Forms.AutoSizeMode.GrowAndShrink
		exportGroupBox.Controls.Add(self.exportButton)
		exportGroupBox.Location = System.Drawing.Point(3, 258)
		exportGroupBox.Name = "exportGroupBox"
		exportGroupBox.Size = System.Drawing.Size(773, 249)
		exportGroupBox.TabIndex = 5
		exportGroupBox.TabStop = false
		exportGroupBox.Text = "Export"
		# 
		# MainForm
		# 
		self.AutoScaleDimensions = System.Drawing.SizeF(6, 13)
		self.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font
		self.ClientSize = System.Drawing.Size(803, 534)
		self.Controls.Add(self.tableLayoutPanel1)
		self.Name = "MainForm"
		self.Text = "OpenZoom Exporter"
		self.importGroupBox.ResumeLayout(false)
		self.importGroupBox.PerformLayout()
		self.tableLayoutPanel1.ResumeLayout(false)
		self.tableLayoutPanel1.PerformLayout()
		exportGroupBox.ResumeLayout(false)
		self.ResumeLayout(false)
	private tableLayoutPanel1 as System.Windows.Forms.TableLayoutPanel
	private importGroupBox as System.Windows.Forms.GroupBox
	private openFileDialog as System.Windows.Forms.OpenFileDialog
	private exportButton as System.Windows.Forms.Button
	private browseSourceFolderButton as System.Windows.Forms.Button
	private sourceFolderTextBox as System.Windows.Forms.TextBox
	private sourceFolderLabel as System.Windows.Forms.Label