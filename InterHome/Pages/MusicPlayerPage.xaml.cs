using CommunityToolkit.Maui.Views;
using InterHome.PageModels;
using Microsoft.Maui.Storage;

namespace InterHome.Pages;

public partial class MusicPlayerPage : ContentPage
{
	public MusicPlayerPage(MusicPlayerPageModel viewModel)
	{
		InitializeComponent();
		BindingContext = viewModel;
		
		// Передаем MediaElement в ViewModel после загрузки страницы
		Loaded += async (s, e) =>
		{
			await LoadMusicFile();
			viewModel.SetMediaElement(MediaPlayer);
		};
	}

	private async Task LoadMusicFile()
	{
		try
		{
			// Загружаем MP3 файл из MauiAsset
			var fileName = "mp3/Bring_Me_The_Horizon_Capital_Voices_Choir_-_Can_You_Feel_My_Heart_47954522.mp3";
			using var stream = await FileSystem.OpenAppPackageFileAsync(fileName);
			
			// Сохраняем временный файл для MediaElement
			var cacheDir = FileSystem.CacheDirectory;
			var tempFile = Path.Combine(cacheDir, "temp_music.mp3");
			
			using (var fileStream = File.Create(tempFile))
			{
				await stream.CopyToAsync(fileStream);
			}
			
			MediaPlayer.Source = MediaSource.FromFile(tempFile);
		}
		catch (Exception ex)
		{
			System.Diagnostics.Debug.WriteLine($"Ошибка загрузки музыки: {ex.Message}");
			// Fallback: пробуем прямой путь
			MediaPlayer.Source = MediaSource.FromFile("mp3/Bring_Me_The_Horizon_Capital_Voices_Choir_-_Can_You_Feel_My_Heart_47954522.mp3");
		}
	}
}
