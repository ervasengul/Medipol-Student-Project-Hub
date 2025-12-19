from django.db import models
from django.utils import timezone
from users.models import User


class Conversation(models.Model):
    """
    Represents a conversation between two or more users.
    Can be one-on-one or group conversation.
    """
    name = models.CharField(max_length=255, blank=True)  # For group chats
    participants = models.ManyToManyField(User, related_name='conversations')
    is_group = models.BooleanField(default=False)
    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)

    class Meta:
        verbose_name = 'Conversation'
        verbose_name_plural = 'Conversations'
        ordering = ['-updated_at']

    def __str__(self):
        if self.is_group:
            return self.name or f"Group Chat {self.id}"
        return f"Conversation {self.id}"

    def get_last_message(self):
        return self.messages.first()  # First because ordered by -created_at

    def get_unread_count(self, user):
        """Get unread message count for a specific user"""
        return self.messages.filter(is_read=False).exclude(sender=user).count()


class Message(models.Model):
    """
    Represents a single message in a conversation
    """
    conversation = models.ForeignKey(
        Conversation,
        on_delete=models.CASCADE,
        related_name='messages'
    )
    sender = models.ForeignKey(
        User,
        on_delete=models.CASCADE,
        related_name='sent_messages'
    )
    content = models.TextField()
    is_read = models.BooleanField(default=False)
    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)

    class Meta:
        verbose_name = 'Message'
        verbose_name_plural = 'Messages'
        ordering = ['-created_at']
        indexes = [
            models.Index(fields=['conversation', '-created_at']),
            models.Index(fields=['sender', '-created_at']),
        ]

    def __str__(self):
        return f"{self.sender.name}: {self.content[:50]}"

    def mark_as_read(self):
        """Mark message as read"""
        self.is_read = True
        self.save(update_fields=['is_read'])
