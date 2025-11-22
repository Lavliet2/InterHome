using InterHome.Models;
using InterHome.PageModels;

namespace InterHome.Pages;

public partial class MainPage : ContentPage
{
	public MainPage(MainPageModel model)
	{
		InitializeComponent();
		BindingContext = model;
	}
}