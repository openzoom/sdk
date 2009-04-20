using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Windows.Data;
using System.Globalization;
using System.Windows;

namespace OpenZoom.Publisher
{
    [ValueConversion(typeof(int), typeof(Visibility))]
    public class ThresholdToVisibilityConverter : IValueConverter
    {
        public object Convert(object value, Type targetType,
                              object parameter, CultureInfo culture)
        {
            return System.Convert.ToInt32(value) > 0 ? Visibility.Visible : Visibility.Collapsed;
        }

        public object ConvertBack(object value, Type targetType,
                                  object parameter, CultureInfo culture)
        {
            throw new NotSupportedException("ThresholdToVisibilityConverter.ConvertBack");
        }
    }

    [ValueConversion(typeof(double), typeof(int))]
    public class ImageQualityToIntConverter : IValueConverter
    {
        public object Convert(object value, Type targetType,
                              object parameter, CultureInfo culture)
        {
            double result = System.Convert.ToDouble(value) * 100.0;

            if (System.Convert.ToBoolean(parameter))
                result = Math.Round(result);

            return System.Convert.ToInt32(result);
        }

        public object ConvertBack(object value, Type targetType,
                                  object parameter, CultureInfo culture)
        {
            return System.Convert.ToInt32(value) / 100.0;
        }
    }
}
