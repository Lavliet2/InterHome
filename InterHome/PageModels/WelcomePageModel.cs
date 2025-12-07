using CommunityToolkit.Mvvm.ComponentModel;

namespace InterHome.PageModels;

public partial class WelcomePageModel : ObservableObject
{
	[ObservableProperty]
	private string welcomeMessage = "Добро пожаловать в InterHome!";

	[ObservableProperty]
	private string description = "Ваше приложение для управления домом и сетью";
}
