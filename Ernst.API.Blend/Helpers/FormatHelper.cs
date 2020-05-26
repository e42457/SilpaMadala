using System.IO;
using System.Linq;
using System.Xml;
using System.Xml.Linq;
using System.Xml.Serialization;

namespace Ernst.Api.Blend.Helpers
{
	public static class FormatHelper
	{
		public static string Serialize<T>(T value)
		{
			if (value == null)
			{
				return string.Empty;
			}
			var xmlserializer = new XmlSerializer(typeof(T));
			var stringWriter = new StringWriter();
			using (var writer = XmlWriter.Create(stringWriter))
			{
				xmlserializer.Serialize(writer, value);
				return stringWriter.ToString();
			}
		}

		public static XElement RemoveNameSpaces(XElement root)
		{
			return new XElement(
				  root.Name.LocalName,
				  root.HasElements ?
					  root.Elements().Select(el => RemoveNameSpaces(el)) :
					  (object)root.Value
			  );
		}
		public static string RemoveXmlDefinition(string xml)
		{
			XmlDocument xdoc = new XmlDocument();
			xdoc.LoadXml(xml);
			var result = xdoc.FirstChild;
			if (result.FirstChild.LocalName == "Response")
			{
				return result.InnerXml.ToString();
			}
			return xdoc.InnerXml.ToString();
		}
	}
}
