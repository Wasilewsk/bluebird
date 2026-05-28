use tauri::Manager;
use tokio::net::TcpListener;
use tokio_tungstenite::accept_async;
use mdns_sd::{ServiceDaemon, ServiceInfo};
use std::net::SocketAddr;
use std::thread;

#[tauri::command]
fn greet(name: &str) -> String {
    format!("Hello, {}! You've been greeted from Rust!", name)
}

async fn start_ws_server() {
    let addr = "0.0.0.0:8080";
    let listener = TcpListener::bind(addr).await.expect("Failed to bind");
    println!("Server listening on: {}", addr);

    while let Ok((stream, _)) = listener.accept().await {
        println!("New connection attempt from: {:?}", stream.peer_addr());
        tokio::spawn(async move {
            match accept_async(stream).await {
                Ok(ws_stream) => {
                    println!("WebSocket handshake successful!");
                    // Handle WebSocket messages here
                }
                Err(e) => println!("Error during handshake: {}", e),
            }
        });
    }
}

#[cfg_attr(mobile, tauri::mobile_entry_point)]
pub fn run() {
    tauri::Builder::default()
        .plugin(tauri_plugin_opener::init())
        .invoke_handler(tauri::generate_handler![greet])
        .setup(|app| {
            tauri::async_runtime::spawn(start_ws_server());
            Ok(())
        })
        .run(tauri::generate_context!())
        .expect("error while running tauri application");
}
