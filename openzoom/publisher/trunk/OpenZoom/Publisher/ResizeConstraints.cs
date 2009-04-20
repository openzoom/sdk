using System;
using System.Drawing;

public interface IResizeConstraint
{
    Size getSize(int width, int height);
}

public class NullConstraint : IResizeConstraint
{
    public int Value
    {
        get;
        set;
    }

    #region IResizeConstraint Members

    public virtual Size getSize(int width, int height)
    {
        return new Size(width, height);
    }

    #endregion
}

public class LongEdgeConstraint : NullConstraint
{
    #region IResizeConstraint Members

    public override Size getSize(int width, int height)
    {
        double aspectRatio = width / (double)height;

        if (aspectRatio > 1.0)
            return new Size(Value, (int)(Value / aspectRatio));
        else
            return new Size((int)(Value * aspectRatio), Value);
    }

    #endregion
}

public class ShortEdgeConstraint : NullConstraint
{
    #region IResizeConstraint Members

    public override Size getSize(int width, int height)
    {
        double aspectRatio = width / (double)height;

        if (aspectRatio > 1.0)
            return new Size((int)(Value * aspectRatio), Value);
        else
            return new Size(Value, (int)(Value / aspectRatio));
    }

    #endregion
}

public class WidthConstraint : NullConstraint
{
    #region IResizeConstraint Members

    public override Size getSize(int width, int height)
    {
        double aspectRatio = width / (double)height;

        if (aspectRatio > 1.0)
            return new Size(Value, (int)(Value / aspectRatio));
        else
            return new Size(Value, (int)(Value * aspectRatio));
    }

    #endregion
}

public class HeightConstraint : NullConstraint
{
    #region IResizeConstraint Members

    public override Size getSize(int width, int height)
    {
        double aspectRatio = width / (double)height;

        if (aspectRatio > 1.0)
            return new Size((int)(Value * aspectRatio), Value);
        else
            return new Size((int)(Value / aspectRatio), Value);
    }

    #endregion
}