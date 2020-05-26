using OTLS.BDD.Framework.Common;
using System;
using System.IO;

namespace Ernst.API.Blend.IntegratedTest.Settings
{
	public class AppSettings : AppSettingsBase
	{
		private static readonly Lazy<AppSettings> lazy = new Lazy<AppSettings>(() => LoadConfiguration<AppSettings>(_configFile));
		private static string _configFile;

		private AppSettings() { }

		public static AppSettings Instance
		{
			get
			{
#if DEBUG
				_configFile = Path.Combine(AppDomain.CurrentDomain.BaseDirectory, "appSettings.json");
#else
                _configFile = Path.Combine(AppDomain.CurrentDomain.BaseDirectory, "appSettings.Release.json");
#endif
				return lazy.Value;
			}
		}

		public string ClientId { get; set; }
		public string ClientSecret { get; set; }
		public string CognitoTokenUrl { get; set; }
	}
}
