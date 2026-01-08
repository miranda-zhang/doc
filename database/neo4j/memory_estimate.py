def neo4j_memory_estimate(
    num_nodes,
    props_per_node,
    rels_per_node,
    props_per_rel,
    node_prop_size=32,   # avg bytes per node property
    rel_prop_size=32,    # avg bytes per relationship property
    node_overhead=64,    # bytes per node overhead
    rel_overhead=64,     # bytes per relationship overhead
    query_overhead_mb=50 # MB for query/transaction objects
):
    # Total node memory
    memory_nodes = num_nodes * (node_overhead + props_per_node * node_prop_size)
    
    # Total relationship memory
    total_rels = num_nodes * rels_per_node
    memory_rels = total_rels * (rel_overhead + props_per_rel * rel_prop_size)
    
    # Page cache estimate (graph data in memory)
    page_cache_bytes = memory_nodes + memory_rels
    
    # Heap estimate (graph + query/transaction objects)
    heap_bytes = page_cache_bytes + query_overhead_mb * 1024 * 1024
    
    # Convert to MB
    page_cache_mb = page_cache_bytes / (1024 * 1024)
    heap_mb = heap_bytes / (1024 * 1024)
    
    return page_cache_mb, heap_mb

# Example: 53k nodes, 50 props per node, 1 rel per node, 1 prop per rel
page_cache, heap = neo4j_memory_estimate(
    num_nodes=53000,
    props_per_node=50,
    rels_per_node=1,
    props_per_rel=1
)

print(f"Estimated page cache: {page_cache:.2f} MB")
print(f"Estimated heap memory: {heap:.2f} MB")
# python3 ./memory_estimate.py
# Estimated page cache: 88.96 MB
# Estimated heap memory: 138.96 MB
