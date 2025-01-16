# DB Version: 17
# OS Type: linux
# DB Type: desktop
# Total Memory (RAM): 24 GB
# CPUs num: 4
# Data Storage: ssd

{ ... }:
{
  services.postgresql.settings = {
    max_connections = 20;
    shared_buffers = "1536MB";
    effective_cache_size = "6GB";
    maintenance_work_mem = "1536MB";
    checkpoint_completion_target = 0.9;
    wal_buffers = "16MB";
    default_statistics_target = 100;
    random_page_cost = 1.1;
    effective_io_concurrency = 200;
    work_mem = "32MB";
    huge_pages = "off";
    min_wal_size = "100MB";
    max_wal_size = "2GB";
    max_worker_processes = 4;
    max_parallel_workers_per_gather = 2;
    max_parallel_workers = 4;
    max_parallel_maintenance_workers = 2;
    wal_level = "minimal";
    max_wal_senders = 0;
  };
}
