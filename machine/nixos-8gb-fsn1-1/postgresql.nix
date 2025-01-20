# DB Version: 13
# OS Type: linux
# DB Type: web
# Total Memory (RAM): 8 GB
# CPUs num: 4
# Data Storage: ssd

{
  pkgs,
  lib,
  ...
}:
{
  services.postgresql = {
    package = lib.mkForce pkgs.postgresql_13_jit;
    settings = {
      max_connections = 200;
      shared_buffers = "2GB";
      effective_cache_size = "6GB";
      maintenance_work_mem = "512MB";
      checkpoint_completion_target = 0.9;
      wal_buffers = "16MB";
      default_statistics_target = 100;
      random_page_cost = 1.1;
      effective_io_concurrency = 200;
      work_mem = "5242kB";
      huge_pages = "off";
      min_wal_size = "1GB";
      max_wal_size = "4GB";
      max_worker_processes = 4;
      max_parallel_workers_per_gather = 2;
      max_parallel_workers = 4;
      max_parallel_maintenance_workers = 2;
      password_encryption = "scram-sha-256";
    };
    enable = true;
  };
}
