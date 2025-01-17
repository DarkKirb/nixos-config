# DB Version: 14
# OS Type: linux
# DB Type: web
# Total Memory (RAM): 16 GB
# CPUs num: 12
# Data Storage: hdd

{
  pkgs,
  lib,
  ...
}:
{
  services.postgresql = {
    package = lib.mkForce pkgs.postgresql_14_jit;
    settings = {
      max_connections = 200;
      shared_buffers = "4GB";
      effective_cache_size = "12GB";
      maintenance_work_mem = "1GB";
      checkpoint_completion_target = 0.9;
      wal_buffers = "16MB";
      default_statistics_target = 100;
      random_page_cost = 4;
      effective_io_concurrency = 2;
      work_mem = "5242kB";
      huge_pages = "off";
      min_wal_size = "1GB";
      max_wal_size = "4GB";
      max_worker_processes = 12;
      max_parallel_workers_per_gather = 4;
      max_parallel_workers = 12;
      max_parallel_maintenance_workers = 4;
    };
    enable = true;
  };
}
