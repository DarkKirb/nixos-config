# DB Version: 17
# OS Type: linux
# DB Type: web
# Total Memory (RAM): 24 GB
# CPUs num: 4
# Data Storage: ssd

{
  ...
}:
{
  services.postgresql = {
    settings = {
      max_connections = 200;
      shared_buffers = "6GB";
      effective_cache_size = "18GB";
      maintenance_work_mem = "1536MB";
      checkpoint_completion_target = 0.9;
      wal_buffers = "16MB";
      default_statistics_target = 100;
      random_page_cost = 1.1;
      effective_io_concurrency = 200;
      work_mem = "15728kB";
      huge_pages = "off";
      min_wal_size = "1GB";
      max_wal_size = "4GB";
      max_worker_processes = 4;
      max_parallel_workers_per_gather = 2;
      max_parallel_workers = 4;
      max_parallel_maintenance_workers = 2;
    };
    enable = true;
    ensureUsers = [
      {
        name = "chir_rs";
        ensureDBOwnership = true;
      }
    ];
    ensureDatabases = [ "chir_rs" ];
  };
  services.pgbouncer.settings.databases = {
    chir_rs = "host=127.0.0.1 port=5432 auth_user=chir_rs dbname=chir_rs";
  };
}
