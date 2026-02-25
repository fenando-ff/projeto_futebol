
from app import App 

if __name__ == "__main__":
    try:
        # Agora o Python reconhece o que é App
        app = App()
        app.mainloop()
    except Exception as e:
        print(f"Erro ao iniciar GUI (esperado no Render): {e}")
        import time
        while True:
            time.sleep(3600)