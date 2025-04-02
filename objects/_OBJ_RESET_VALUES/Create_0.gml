RestartEventSystem();
global.vars = new Vars();

loadStack = ds_stack_create();

ds_stack_push(loadStack, new LoaderGameData());
ds_stack_push(loadStack, new LoaderAssets());
ds_stack_push(loadStack, new LoaderSystem());


