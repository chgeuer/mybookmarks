MySQL
-----

- [Windows Azure MySQL PHP Solution Accelerator](http://archive.msdn.microsoft.com/winazuremysqlphp/)
- [MySQL hosted on Windows Azure (Feb 2010)](http://blogs.staykov.net/2010/02/mysql-hosted-on-windows-azure.html) basically says that MySQL in a single-instance worker role sucks
- [GETTING MYSQL RUNNING ON AZURE](http://www.joshholmes.com/blog/2010/02/09/gettingmysqlrunningonazure/)
- [High Availability MySQL Cookbook , EUR 17,-](http://www.packtpub.com/high-availability-mysql-cookbook/book)

MySQL has different storage engines, MyISAM, InnoDB and NDB. 
For a MySQL Cluster, we need NDB (Network DataBase), sometimes called NDBCLUSTER.
A cluster has three node types: 

1. Management Node - must be started first (joined by the others then). 
2. Data / Storage Node - the ndbd process. One or mode
3. API / SQL Nodes - the mysqld process in front of the data nodes, which answers the SQL queries

For HA, we must have >= 1 mgmt node, >= 2 data nodes, >= 2 SQL nodes. 
Simplest cluster is small machine with mgmt and 2 identical boxes with data+SQL processes.
SQL nodes must be having the input endpoint. All other nodes communicate in VNet. 