package hack.connections.db;

import org.skife.jdbi.v2.sqlobject.Bind;
import org.skife.jdbi.v2.sqlobject.SqlQuery;
import org.skife.jdbi.v2.sqlobject.SqlUpdate;

public interface DeviceDAO {

    @SqlUpdate("create table devices (macaddr string primary key, lastSeenIpAddr string, lastSeenWhen long, visibleName varchar(100))")
    void createSomethingTable();

    @SqlUpdate("insert into devices (macaddr, lastSeenIpAddr) values (:macaddr, :lastSeenIpAddr)")
    void insert(@Bind("macaddr") int macaddr, @Bind("ipaddr") String ipaddr);

    @SqlQuery("select lastSeenIpAddr from devices where macaddr = :macaddr")
    String findNameById(@Bind("id") int id);
}
