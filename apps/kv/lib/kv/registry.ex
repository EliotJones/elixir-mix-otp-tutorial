defmodule KV.Registry do
    use GenServer
    
    # Client API
    
    def start_link(proc_name) do
        GenServer.start_link(__MODULE__, proc_name, name: proc_name)
    end
    
    def lookup(server, name) when is_atom(server) do
        case :ets.lookup(server, name) do
            [{^name, bucket}] -> {:ok, bucket}
            [] -> :error
        end
    end
    
    def create( server, name) do
        GenServer.call(server, {:create, name})
    end
    
    def stop(server) do
        GenServer.stop(server)
    end
    
    # Server api
    def init(table) do
        names = :ets.new(table, [:named_table, read_concurrency: true])
        refs = %{}
        {:ok, {names, refs}}
    end
    
    def handle_call({:create, name}, _from, {names, refs}) do
        case lookup(names, name) do
            {:ok, pid} ->
                {:reply, pid, {names, refs}}
            :error ->
                {:ok, bucket} = KV.Bucket.Supervisor.start_bucket()
                ref = Process.monitor bucket
                refs = Map.put refs, ref, name
                :ets.insert(names, {name, bucket})
                {:reply, bucket, {names, refs}}
        end
    end
    
    def handle_info({:DOWN, ref, :process, _pid, _reason}, {names, refs}) do
        {name, refs} = Map.pop(refs, ref)
        :ets.delete(names, name)
        {:noreply, {names, refs}}
    end
    
    def handle_info(_msg, state) do
        {:noreply, state}
    end
end