using CommunityToolkit.Maui.Core;
using CommunityToolkit.Maui.Views;
using CommunityToolkit.Mvvm.ComponentModel;
using CommunityToolkit.Mvvm.Input;

namespace InterHome.PageModels;

public partial class MusicPlayerPageModel : ObservableObject
{
	[ObservableProperty]
	private bool isPlaying;

	[ObservableProperty]
	private string currentTrackName = "Can You Feel My Heart";

	[ObservableProperty]
	private string currentArtist = "Bring Me The Horizon";

	[ObservableProperty]
	private TimeSpan position = TimeSpan.Zero;

	[ObservableProperty]
	private TimeSpan duration = TimeSpan.Zero;

	private MediaElement? _mediaElement;

	public void SetMediaElement(MediaElement mediaElement)
	{
		_mediaElement = mediaElement;
		_mediaElement.MediaOpened += OnMediaOpened;
		_mediaElement.MediaEnded += OnMediaEnded;
		_mediaElement.PositionChanged += OnPositionChanged;
	}

	private void OnMediaOpened(object? sender, EventArgs e)
	{
		if (_mediaElement != null)
		{
			Duration = _mediaElement.Duration;
		}
	}

	private void OnMediaEnded(object? sender, EventArgs e)
	{
		IsPlaying = false;
		Position = TimeSpan.Zero;
	}

	private void OnPositionChanged(object? sender, MediaPositionChangedEventArgs e)
	{
		Position = e.Position;
	}

	[RelayCommand]
	private void PlayPause()
	{
		if (_mediaElement == null) return;

		if (IsPlaying)
		{
			_mediaElement.Pause();
			IsPlaying = false;
		}
		else
		{
			_mediaElement.Play();
			IsPlaying = true;
		}
	}

	[RelayCommand]
	private void Stop()
	{
		if (_mediaElement == null) return;

		_mediaElement.Stop();
		IsPlaying = false;
		Position = TimeSpan.Zero;
	}

	public string PlayPauseButtonText => IsPlaying ? "⏸ Пауза" : "▶ Воспроизвести";
}
