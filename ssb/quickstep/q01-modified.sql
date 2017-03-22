select p_category, lo_discount 
from lineorder,part 
where lo_partkey = p_partkey
      and (p_category = 'MFGR#11' or 
           p_category = 'MFGR#21' or
           p_category = 'MFGR#31' or 
           p_category = 'MFGR#41' or 
           p_category = 'MFGR#12' or
           p_category = 'MFGR#22' or 
           p_category = 'MFGR#32' or 
           p_category = 'MFGR#42' or 
           p_category = 'MFGR#13' or
           p_category = 'MFGR#23' or 
           p_category = 'MFGR#33' or 
           p_category = 'MFGR#43' or 
           p_category = 'MFGR#14' or 
           p_category = 'MFGR#24' or
           p_category = 'MFGR#34' or 
           p_category = 'MFGR#44' or 
           p_category = 'MFGR#15' or 
           p_category = 'MFGR#25' or 
           p_category = 'MFGR#35' or 
           p_category = 'MFGR#45'  
        );
--		and lo_discount between 1 and 3
--		and lo_quantity < 25;
