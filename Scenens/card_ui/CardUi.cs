using Godot;
using System.Collections.Generic;

public class CardUI : Control
{
    // Signals
    [Signal]
    public delegate void ReparentRequested(CardUI whichCardUI);

    // Properties
    [Export]
    public Card card;
    
    [Export]
    public PackedScene scene;

    // Node references
    private Color color;
    private State state;
    private CardStateMachine cardStateMachine;
    private Area2D dropPointDetector;
    private List<Node> targets = new List<Node>();
    private Node released;

    private Control parent;
    private Tween tween;
    private Vector2 scenePosition;

    public override void _Ready()
    {
        cardStateMachine.Init(this);
        released.Connect("is_played", this, nameof(Played));
    }

    public override void _Input(InputEvent @event)
    {
        cardStateMachine.OnInput(@event);
    }

    private void _OnGuiInput(InputEvent @event)
    {
        cardStateMachine.OnGuiInput(@event);
    }

    private void _OnMouseEntered()
    {
        cardStateMachine.OnMouseEntered();
    }

    private void _OnMouseExited()
    {
        cardStateMachine.OnMouseExited();
    }

    private void _OnDropPointDetectorAreaEntered(Area2D area)
    {
        if (!targets.Contains(area))
        {
            targets.Add(area);
        }
    }

    private void _OnDropPointDetectorAreaExited(Area2D area)
    {
        targets.Remove(area);
    }

    public void AnimateToPosition(Vector2 newPosition, float duration)
    {
        tween = CreateTween();
        tween.SetTrans(Tween.TransType.Cubic);
        tween.SetEase(Tween.EaseType.Out);
        tween.TweenProperty(this, "global_position", newPosition, duration);
    }

    private void _OnReleasedStateCardEnded()
    {
        // Replace with function body.
    }

    public void Played(Vector2 a)
    {
        if (scene == null)
        {
            return;
        }

        var sceneInstance = scene.Instantiate();
        sceneInstance.Position = new Vector2(Events.pos.x - Position.x, Events.pos.y - Position.y);
        GD.Print(Events.pos);
        AddChild(sceneInstance);
        scene = null;
    }
}
