dialect "none"
import "standardBundle" as standardBundle
import "objectdrawBundle" as objectdrawBundle
import "requireTypes" as requireTypes

use standardBundle.open
use objectdrawBundle.open

def thisDialect is public = requireTypes.thisDialect
