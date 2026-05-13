class MinigameRouter:
    """
    Um roteador para controlar as operações de banco de dados no app minigame.
    """
    route_app_labels = {'minigame'}

    def db_for_read(self, model, **hints):
        """Aponta operações de leitura para o banco 'minigame' se o model for deste app."""
        if model._meta.app_label in self.route_app_labels:
            return 'minigame'
        return None

    def db_for_write(self, model, **hints):
        """Aponta operações de escrita para o banco 'minigame' se o model for deste app."""
        if model._meta.app_label in self.route_app_labels:
            return 'minigame'
        return None

    def allow_relation(self, obj1, obj2, **hints):
        """Permite relações se ambos os models estiverem no app minigame."""
        if (
            obj1._meta.app_label in self.route_app_labels or
            obj2._meta.app_label in self.route_app_labels
        ):
            return True
        return None

    def allow_migrate(self, db, app_label, model_name=None, **hints):
        """Garante que os models do app minigame só sejam migrados no banco 'minigame'."""
        if app_label in self.route_app_labels:
            return db == 'minigame'
        return None