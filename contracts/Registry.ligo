type package_info is record [
  owner : address;
  path  : string;
]

type registry is big_map (string, package_info)

type registry_entry is string * package_info

type action is
| Register of registry_entry
| Deregister of string

type return is list (operation) * registry

function register_package (const entry : registry_entry; const package_registry : registry) : registry is
  block { case package_registry[entry.0] of
    // check if allowed to register this package
    Some (package) -> if package.owner =/= Tezos.source then {
        failwith ("Access Denied.");
      } else {
        package_registry[entry.0] := entry.1;
      }
  | None -> package_registry[entry.0] := entry.1
  end} with package_registry

function deregister_package (const name : string; const package_registry : registry) : registry is
  block { case package_registry[name] of
    Some (package) -> if package.owner =/= Tezos.source then {
        failwith ("Access Denied.");
      } else {
        remove name from map package_registry;
      }
  | None -> failwith("No such package.")
  end} with package_registry

function main (const p : action; const package_registry: registry) : return is
  ((nil : list(operation)),
   case p of
     Register(package) -> register_package(package, package_registry)
   | Deregister(package_name) -> deregister_package(package_name, package_registry)
   end)
