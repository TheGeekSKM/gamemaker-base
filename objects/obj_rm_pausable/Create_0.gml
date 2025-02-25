#region Pausing Logic
	if (!pauseable_FreezeStep)
	{
		Subscribe("Pause", function (_id) { OnPause(); });
		Subscribe("Resume", function (_id) { OnResume(); });
	}

	function OnPause() {} // only use if you want to have custom pausing logic
	function OnResume() {} // only use if you want to have custom pausing logic
#endregion