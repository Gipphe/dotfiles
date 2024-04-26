{ hostname, ... }:
{
  programs.barrier.client = {
    enable = true;
    enableDragDrop = true;
    machine.name = hostname;
  };
}
