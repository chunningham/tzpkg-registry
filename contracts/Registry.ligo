type package_info is record [
  owner : address;
  path  : string;
]

type registry is big_map (string, package_info)

type registry_entry is string * package_info

type action is
| Register of registry_entry

type return is list (operation) * registry

function register_package (const entry : registry_entry; const package_registry: registry) : registry is
  block { case package_registry[entry.0] of
    // check if allowed to register this package
    Some (package) -> if package.owner =/= Tezos.source then failwith ("Access Denied.") else package_registry[entry.0] := entry.1
    None -> package_registry[entry.0] := entry.1
  } with package_registry

function main (const p : action; const package_registry: registry) : return is
  ((nil : list(operation)),
   case p of
     Register(package) -> register_package(package, package_registry)
   end)
