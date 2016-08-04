CREATE LOCATION tpchdata WITH AREA = '/fastdisk/vectorwise-data/tpch-sf100/data', USAGE = (DATABASE)\g;
CREATE LOCATION tpchcheckpoint WITH AREA = '/fastdisk/vectorwise-data/tpch-sf100/checkpoint', USAGE = (CHECKPOINT)\g;
CREATE LOCATION tpchjournal WITH AREA = '/fastdisk/vectorwise-data/tpch-sf100/journal', USAGE = (JOURNAL)\g;
CREATE LOCATION tpchdump WITH AREA = '/fastdisk/vectorwise-data/tpch-sf100/dump', USAGE = (DUMP)\g;
CREATE LOCATION tpchwork WITH AREA = '/fastdisk/vectorwise-data/tpch-sf100/work', USAGE = (WORK)\g;
