import sys

def add_predicate_or(predicate_list, num_predicates):
    return " OR\n".join(['\t' + str(curr_pred) for curr_pred in predicate_list[:num_predicates]])

'''
 relation_names : list of relations
'''
def add_relations_from(relation_names):
    return 'FROM ' + ", ".join([str(rel_name) for rel_name in relation_names]) + '\n'

def add_project_atributes(project_attr_list):
    return 'SELECT ' + ", ".join([str(attr_name) for attr_name in project_attr_list]) + '\n'

def add_join_condition(join_attributes):
    return 'WHERE ' + " = ".join([str(join_attr_name) for join_attr_name in join_attributes]) + '\n'

if __name__ == "__main__":
    predicate_list = ["p_category = 'MFGR#11'","p_category = 'MFGR#21'","p_category = 'MFGR#31'","p_category = 'MFGR#41'","p_category = 'MFGR#12'","p_category = 'MFGR#22'","p_category = 'MFGR#32'","p_category = 'MFGR#42'","p_category = 'MFGR#13'","p_category = 'MFGR#23'","p_category = 'MFGR#33'","p_category = 'MFGR#43'","p_category = 'MFGR#14'","p_category = 'MFGR#24'","p_category = 'MFGR#34'","p_category = 'MFGR#44'","p_category = 'MFGR#15'","p_category = 'MFGR#25'","p_category = 'MFGR#35'","p_category = 'MFGR#45'"]
    from_list = ["lineorder", "part"]
    project_list = ["count(*)"]
    join_attributes = ["lo_partkey", "p_partkey"]

    query_str = ""
    query_str = query_str + add_project_atributes(project_list)
    query_str = query_str + add_relations_from(from_list)
    query_str = query_str + add_join_condition(join_attributes)
    query_str = query_str + 'AND (\n'
    query_str = query_str + add_predicate_or(predicate_list, int(sys.argv[1]))
    query_str = query_str + '\n);'

    print query_str
