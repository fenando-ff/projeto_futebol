if __name__ == "__main__":
    try:
        app = App()
        app.mainloop()
    except Exception as e:
        print(f"Erro ao iniciar GUI (esperado no Render): {e}")
        # Mantenha o processo vivo para o Render não dar erro de saída
        import time
        while True:
            time.sleep(3600)