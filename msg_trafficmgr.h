#ifndef __MSG_GROUP_TRAFFICMGR_H__
#define __MSG_GROUP_TRAFFICMGR_H__

/* This file defines all the msg IDs within TRAFFICMGR
 * Define request and response message ID in a pair. i.e.  <n, n+1>
 */

#include <msg_common.h>
#include <msg_group.h>

#undef DEFINE_ENUM
// adding prefix to avoid conflict
#define DEFINE_ENUM(name) TRAFFICMGR_##name

typedef enum {
    DEFINE_ENUM(MGMT_CFG_CLASS_MAP_REQ)  = 0,
    DEFINE_ENUM(MGMT_CFG_CLASS_MAP_RSP)  = 1,
    DEFINE_ENUM(MGMT_CFG_POLICY_MAP_REQ)  = 2,
    DEFINE_ENUM(MGMT_CFG_POLICY_MAP_RSP)  = 3,
    DEFINE_ENUM(MGMT_CFG_SERVICE_DYNAMIC_TEMPLATE_REQ)  = 4,
    DEFINE_ENUM(MGMT_CFG_SERVICE_DYNAMIC_TEMPLATE_RSP)  = 5,
    DEFINE_ENUM(VIA_REQ)                                        = 6,
    DEFINE_ENUM(VIA_RSP)                                        = 7,
    DEFINE_ENUM(LAST_ONE)
}MSGTrafficmgr;

#if DEFINE_ENUM(LAST_ONE) > MSG_PER_GROUP
#error "Exceeding max number of messages per group, create a new group to continue"
#endif

#endif
