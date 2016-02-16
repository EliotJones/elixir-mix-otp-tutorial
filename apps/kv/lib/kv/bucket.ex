defmodule KV.Bucket do
    @doc """
    Starts a new bucket
    """
    def start_link do
        Agent.start_link(fn -> %{} end)
    end
    
    @doc """
    Gets a value from the bucket by key
    """
    def get(bucket, key) do
        # Equivalent to: Agent.get(bucket, fn b -> Map.get(b, key) end)
        Agent.get(bucket, &(Map.get(&1, key)))
    end
    
    @doc """
    Puts the key value pair in the bucket
    """
    def put(bucket, key, value) do
        # Equivalent to: Agent.update(bucket, fn b -> Map.put(b, key, value) end)
        Agent.update(bucket, &(Map.put(&1, key, value)))
    end
    
    @doc """
    Deletes the key value pair for the key
    """
    def delete(bucket, key) do
        # Equivalent to: Agent.get_and_update(bucket, fn b -> Map.pop(b, key) end)
        Agent.get_and_update(bucket, &Map.pop(&1, key))
    end

    @doc """
    Puts the key value pair in the bucket and returns the value
    (Not included in the tutorial guide)
    """        
    def put_and_get(bucket, key, value) do
        Agent.update(bucket, fn b -> Map.put(b, key, value) end)
         
        Agent.get(bucket, fn b -> Map.get(b, key) end)
    end
end