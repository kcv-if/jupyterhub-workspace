c = get_config()

# Shutdown kernel after 1 hour idle
c.MappingKernelManager.cull_idle_timeout = 3600

# Check every 60 seconds
c.MappingKernelManager.cull_interval = 60

# Cull even if kernel has connections
c.MappingKernelManager.cull_connected = True

# Optional: shutdown server when no kernels & inactive
c.ServerApp.shutdown_no_activity_timeout = 3600

# code-server via jupyter-server-proxy
c.ServerProxy.servers = {
    'vscode': {
        'command': [
            'code-server',
            '--bind-addr', '0.0.0.0:{port}',
            '--auth', 'none',
            '--disable-update-check',
            '--disable-workspace-trust',
            '/home/jovyan/work',
        ],
        'timeout': 20,
        'absolute_url': False,
        # Report activity to Jupyter server when code-server has active connections
        # This prevents the idle culler from shutting down while a user is in VS Code
        'activity_interval': 30,
        'launcher_entry': {
            'title': 'VS Code',
        },
    },
}
