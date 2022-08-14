_: {
  programs.taskwarrior = {
    enable = true;
    colorTheme = "dark-violets-256";
    config = {
      weekstart = "monday"; # no americans, the week does not start with week-end
    };
    dataLocation = "~/Data/tasks/";
  };
}
