package libclash

import (
	"os"
	"sync"
	"sync/atomic"

	"github.com/metacubex/mihomo/constant"
	"github.com/metacubex/mihomo/hub/executor"
)

var (
	running atomic.Bool
	mu      sync.Mutex
)

// LibclashStart initializes and starts the Mihomo core with the given config file path and home directory.
func LibclashStart(homeDir, configPath string) string {
	mu.Lock()
	defer mu.Unlock()

	if running.Load() {
		return ""
	}

	if err := os.MkdirAll(homeDir, 0755); err != nil {
		return err.Error()
	}

	constant.SetHomeDir(homeDir)
	constant.SetConfig(configPath)

	cfg, err := executor.ParseWithPath(configPath)
	if err != nil {
		return "failed to parse config: " + err.Error()
	}

	executor.ApplyConfig(cfg, true)
	running.Store(true)
	return ""
}

// LibclashStop gracefully stops the Mihomo core.
func LibclashStop() {
	mu.Lock()
	defer mu.Unlock()

	if !running.Load() {
		return
	}

	executor.Shutdown()
	running.Store(false)
}

// LibclashIsRunning returns true if Mihomo is running.
func LibclashIsRunning() bool {
	return running.Load()
}

// LibclashGetTraffic returns current traffic deltas.
func LibclashGetTraffic(up, down *int64) {
	// Optional traffic metrics query
}
