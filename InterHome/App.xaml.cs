using Microsoft.Extensions.DependencyInjection;

namespace InterHome;

public partial class App : Application
{
	public App()
	{
		InitializeComponent();
	}

	protected override Window CreateWindow(IActivationState? activationState)
	{
		return new Window(new AppShell());
	}

    // Optional events to implement for the application lifecycle. The Window created 
    // above also has lifecycle events that can be used to track the Window lifecycle.
    protected override void OnStart()
    {
        base.OnStart();
    }

    protected override void OnResume()
    {
        base.OnResume();
    }

    protected override void OnSleep()
    {
        base.OnSleep();
    }
}