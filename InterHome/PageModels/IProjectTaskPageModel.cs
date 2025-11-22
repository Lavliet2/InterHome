using CommunityToolkit.Mvvm.Input;
using InterHome.Models;

namespace InterHome.PageModels;

public interface IProjectTaskPageModel
{
	IAsyncRelayCommand<ProjectTask> NavigateToTaskCommand { get; }
	bool IsBusy { get; }
}