"""
Central runtime boundary for cairo wrapper internals.

The current bindgen layer resolves libcairo symbols lazily; wrapper objects do not
carry any loader state.
"""

def ensure_runtime_ready() raises:
    # Kept as an explicit seam for future runtime initialization.
    pass
