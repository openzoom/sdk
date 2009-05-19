package org.openzoom.flash.utils
{

public class MIMEUtil
{
    public static function getContentType(extension:String):String
    {
        var type:String

        switch (extension)
        {
            case "jpg":
               type = "image/jpeg"
               break
               
            case "jpeg":
               type = "image/jpeg"
               break

            case "png":
               type = "image/png"
               break

            default:
               throw new ArgumentError("Unknown extension: " + extension)
               break
        }

        return type
    }
}

}