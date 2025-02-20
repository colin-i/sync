
const debug_none=0
const debug_log=0x1
const debug_alt=0x2
const debug_titles=0x4
const debug_x=0x8
const debug_x_pad=0x10

const flag_forin1=0x20
const flag_framesAsShows=0x40

const flag_x=0x80           #will turn off antix_read flags
const flag_pool_write=0x100
const flag_pool_read=0x200  #will turn off flag_pool_write

const debug_xpad=debug_x|debug_x_pad
const flags_pool=flag_pool_write|flag_pool_read
const flags_x=debug_x|flag_x
const prexx_flags=debug_log|flag_pool_write|debug_x
const xx_flags=debug_log|flag_pool_read|flag_x
const antix_read=debug_log|debug_alt|debug_xpad
