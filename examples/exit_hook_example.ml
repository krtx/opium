(* How to clean up and exit an opium app *)
open Core_kernel.Std
open Opium.Std

let hello = get "/" (fun req -> `String "Hello World" |> respond')

let () =
  let app =
    App.empty
    |> hello
    |> App.run_command' in
  match app with
  | `Ok app ->
    Lwt_main.at_exit (fun () -> return (print_endline "Testing"));
    let s = Lwt.join [app; Lwt_unix.sleep 2.0 >>| fun _ -> Lwt.cancel app] in
    ignore (Lwt_main.run s)
  | `Error -> exit 1
  | `Not_running -> exit 0
