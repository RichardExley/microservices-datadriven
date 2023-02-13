-- Copyright (c) 2022, Oracle and/or its affiliates.
-- Licensed under the Universal Permissive License v 1.0 as shown at https://oss.oracle.com/licenses/upl.

GRANT AQ_ADMINISTRATOR_ROLE TO NOTIFICATIONS;
GRANT EXECUTE ON DBMS_AQADM TO NOTIFICATIONS;
GRANT EXECUTE ON DBMS_AQ TO NOTIFICATIONS;
COMMIT;

BEGIN
    DBMS_AQADM.CREATE_SHARDED_QUEUE(
        QUEUE_NAME => 'notifications.NOTIFICATION_QUEUE',
        MULTIPLE_CONSUMERS => TRUE
    );
    DBMS_AQADM.START_QUEUE('notifications.NOTIFICATION_QUEUE');
    DBMS_AQADM.ADD_SUBSCRIBER( QUEUE_NAME=>'notifications.NOTIFICATION_QUEUE', SUBSCRIBER=>SYS.AQ$_AGENT('NOTIFICATIONS_SUBS', NULL, NULL) );
END;
/
COMMIT;
/