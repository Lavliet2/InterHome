using InterHome.PageModels;

namespace InterHome.Pages;

public partial class WelcomePage : ContentPage
{
	public WelcomePage(WelcomePageModel viewModel)
	{
		InitializeComponent();
		BindingContext = viewModel;
	}
}
